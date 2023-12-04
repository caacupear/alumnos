public with sharing class ConstanciaHelper {
    

    public static void validateContent(List<Constancia__c> constancias){
        Set<String> contactFields = Contact.getSobjectType().getDescribe().fields.getMap().keySet();

        for( Constancia__c constancia : constancias) {
            Set<String> variables = getVariables(constancia.Contenido__c);
            Boolean hasAllaVariables = contactFields.containsAll(variables);
            if( !hasAllaVariables ) {
                constancia.addError('Hay campos que no existen en el contact');
            }
        }
    }

    private static boolean hasSObjectField(String fieldName, SObject so){
        return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }

    public static Set<String> getKeys( String contentido ) {
        Pattern varRegex = Pattern.compile('\\{[a-zA-Z_0-9]*\\}');
        Matcher matcher = varRegex.matcher(contentido);
        Set<String> variables = new Set<String>();
        while (matcher.find()) { 
            variables.add(matcher.group());
        }
        return variables;
    }

    public static Set<String> getVariables( String contentido ) {
        Pattern varRegex = Pattern.compile('\\{[a-zA-Z_0-9]*\\}');
        Matcher matcher = varRegex.matcher(contentido);
        Set<String> variables = new Set<String>();
        Set<String> fields = new Set<String>{'titulo', 'fecha'};
        while (matcher.find()) { 
            variables.add(matcher.group().substringBetween('{', '}').toLowerCase());
        }
        variables.removeAll(fields);

        return variables;
    }

    public static String mergeFields( String contentido, Contact contact, Map<String, Object> fields ) {
        Map<String, Object> mapVarValues = new Map<String, String>();  
        
        for ( String key : getKeys(contentido) ) {
            String variable = key.substringBetween('{', '}').toLowerCase();
            if ( !mapVarValues.containsKey(key)) {
                if ( fields.containsKey(variable) ) {
                    mapVarValues.put(key, fields.get(variable) );
                } else if ( hasSObjectField(variable, contact) ) {
                    mapVarValues.put(key, contact.get(variable) );
                } else {
                    mapVarValues.put(key, key );
                }
            }
        }
        for ( String key : mapVarValues.keySet() ){
            contentido = contentido.replace(key, String.valueOf(mapVarValues.get(key)) );
        }

        return contentido;
    }

    @AuraEnabled
    public static List<Constancia__c> fetchConstancias(){
        return  [SELECT Id, Name, Descripcion__c, Adjuntar__c From Constancia__c];
    }
    
    static public String getContent( String idConstancia, String idContact ) {
        // Query Data
        Constancia__c constancia = [SELECT Name, Nombre__c, Contenido__c, guardaUltimo__c, Adjuntar__c From Constancia__c WHERE Id = :idConstancia];
        Map<String, Object> fields = new Map<String, Object>{'titulo' => constancia.Name, 'fecha' => Date.today().format() };
        Set<String> variables = getVariables(constancia.Contenido__c);        
        Contact contacto = Database.query('SELECT ' +  String.join(variables,',') + ' From Contact WHERE Id = :idContact');
        return mergeFields( constancia.Contenido__c, contacto,  fields);
    }

    @AuraEnabled
    public static Attachment generatePDF(String idConstancia, String idContact){
        Constancia__c constancia = [SELECT Name, Nombre__c, Contenido__c, guardaUltimo__c, Adjuntar__c From Constancia__c WHERE Id = :idConstancia];
        
        String content = getContent(idConstancia, idContact);
        // Generate PDF
        Pagereference pg = Page.RenderAsPDF;
        System.debug(content);
        //content = '<p><strong>Reserva Vacante</strong></p><p><br></p><p>Se deja constancia que, Juan <span style="color: rgb(68, 68, 68); background-color: rgb(255, 255, 255);">De los palotes</span></p><p><br></p><p>que acredita identidad con con DNI número 233333</p><p><br></p><p>TIENE RESERVADA UNA VACANTE EN ESTE INSTITUTO.-</p><p><br></p><p>En la Ciudad ';
        pg.getParameters().put('body',  EncodingUtil.urlEncode(content, 'UTF-8'));
        Blob pdf = pg.getContentAsPDF();
        
        // Generate Attachment
        Attachment objAttachment = new Attachment();
        objAttachment.Name = Constancia__c.Nombre__c + '.pdf';
        objAttachment.ParentId = idContact;
        objAttachment.Body = pdf;   
        objAttachment.IsPrivate = false;

        if ( constancia.Adjuntar__c ) {
            insert objAttachment;
        }

        return objAttachment;
    }


}