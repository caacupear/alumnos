public with sharing class ConstanciaHelper {
  private static Map<String, String> formulasVal;
  private static Map<String, String> mapObjects = new Map<String, string>{
    'constancia' => 'Constancia__c',
    'contacto' => 'Contact',
    'boletin' => 'Boletin__c',
    'division' => 'Division__c',
    'ciclo' => 'CicloLectivo__c',
    'programa' => 'Programa__c'
  };

  private static Map<String, String> formulas {
    get {
      if (formulasVal == null) {
        Date hoy = Date.today();
        formulasVal = new Map<String, String>{
          'fecha' => hoy.format(),
          'hoy_dia' => String.valueOf(hoy.day()),
          'hoy_mes' => String.valueOf(hoy.month()),
          'hoy_anio' => String.valueOf(hoy.year()),
          'pagenumber' => '<span class="pagenumber"/>',
          'pagecount' => '<span class="pagecount"/>'
        };
      }
      return formulasVal;
    }
    set {
      formulasVal = value;
    }
  }

  public static String checkContentVariables(String content) {
    if (content != null) {
      Map<String, Set<String>> mapFields = getMapFields(content);
      for (String objeto : mapFields.keySet()) {
        Set<String> notFound = notFoundFields(objeto, mapFields.get(objeto));

        if (notFound.size() > 0) {
          String errorMessage = String.format(
            'Hay campos que no existen en el {0}: {1}',
            new List<Object>{ objeto, notFound }
          );
          return errorMessage;
        }
      }
    }
    return null;
  }

  public static void validateContent(List<Constancia__c> constancias) {
    for (Constancia__c constancia : constancias) {
      String errorMessage = checkContentVariables(constancia.Nombre__c);
      if (String.isNotEmpty(errorMessage)) {
        constancia.Nombre__c.addError(errorMessage);
      }
      errorMessage = checkContentVariables(constancia.Contenido__c);
      if (String.isNotEmpty(errorMessage)) {
        constancia.Contenido__c.addError(errorMessage);
      }
    }
  }

  private static Set<String> notFoundFields(String objeto, Set<String> fields) {
    Set<String> objectFields;
    if (objeto == 'formulas') {
      objectFields = formulas.keySet();
    } else {
      String objectName = mapObjects.get(objeto);
      objectFields = Schema.getGlobalDescribe()
        .get(objectName)
        .getDescribe()
        .fields.getMap()
        .keySet();
    }

    fields.removeAll(objectFields);
    return fields;
  }

  private static String[] splitObject(String key) {
    String[] match = key.substringBetween('{', '}')
      .toLowerCase()
      .split('\\.', 2);
    String objeto = match.size() == 2
      ? match.get(0)
      : formulas.containsKey(match.get(0)) ? 'formulas' : 'contacto';
    String variable = match.size() == 2 ? match.get(1) : match.get(0);
    return new List<String>{ objeto, variable };
  }

  private static Map<String, Set<String>> getMapFields(String contentido) {
    Pattern varRegex = Pattern.compile('\\{[a-zA-Z_0-9\\.]*\\}');
    Matcher matcher = varRegex.matcher(contentido);
    Set<String> groupsValidos = mapObjects.keySet();
    Map<String, Set<String>> mapFields = new Map<String, Set<String>>();

    while (matcher.find()) {
      String[] match = splitObject(matcher.group());
      String objeto = match[0];
      String variable = match[1];

      if (groupsValidos.contains(objeto) || objeto == 'formulas') {
        if (!mapFields.containsKey(objeto)) {
          mapFields.put(objeto, new Set<String>{ variable });
        } else {
          mapFields.get(objeto).add(variable);
        }
      } else {
        String errorMessage = String.format(
          'El objeto {0} no esta en la lista de posibles objetos: {1}',
          new List<Object>{ objeto, groupsValidos }
        );
        throw new ApplicationException(errorMessage);
      }
    }
    return mapFields;
  }

  private static Set<String> getKeys(String contentido) {
    Pattern varRegex = Pattern.compile('\\{[a-zA-Z_0-9\\.]*\\}');
    Matcher matcher = varRegex.matcher(contentido);
    Set<String> variables = new Set<String>();
    while (matcher.find()) {
      variables.add(matcher.group());
    }
    return variables;
  }

  public static String mergeFields(
    String contentido,
    Map<String, SObject> objects
  ) {
    Map<String, Object> mapVarValues = new Map<String, String>();

    for (String key : getKeys(contentido)) {
      String[] match = splitObject(key);
      String objeto = match[0];
      String variable = match[1];

      if (objeto == 'formulas') {
        mapVarValues.put(key, formulas.get(variable));
      } else {
        mapVarValues.put(key, objects.get(objeto).get(variable));
      }
    }

    for (String key : mapVarValues.keySet()) {
      contentido = contentido.replace(
        key,
        String.valueOf(mapVarValues.get(key))
      );
    }

    return contentido;
  }

  @AuraEnabled
  public static List<Constancia__c> fetchConstancias() {
    return [SELECT Id, Name, Descripcion__c, Adjuntar__c FROM Constancia__c];
  }

  private static Map<String, String> getMapRecordId(Id idContact) {
    Contact contactLookForId = [
      SELECT
        Id,
        UltimoBoletin__c,
        UltimoBoletin__r.Division__c,
        UltimoBoletin__r.Division__r.CicloLectivo__c,
        UltimoBoletin__r.Division__r.CicloLectivo__r.Programa__c
      FROM Contact
      WHERE Id = :idContact
    ];

    return (new Map<String, String>{
      'contacto' => contactLookForId.Id,
      'boletin' => contactLookForId.UltimoBoletin__c,
      'division' => contactLookForId.UltimoBoletin__r.Division__c,
      'ciclo' => contactLookForId.UltimoBoletin__r.Division__r.CicloLectivo__c,
      'programa' => contactLookForId.UltimoBoletin__r.Division__r.CicloLectivo__r.Programa__c
    });
  }

  private static ContentVersion attachDocument(
    String title,
    Blob content,
    Id parentId,
    String fileType
  ) {
    // Generate Attachment
    ContentVersion cVersion = new ContentVersion(
      PathOnClient = title + '.' + fileType,
      Title = title,
      VersionData = content,
      IsMajorVersion = true
    );
    List<ContentDocumentLink> existDocument = [
      SELECT ContentDocumentId
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :parentId AND ContentDocument.title = :title
      LIMIT 1
    ];
    // Si ya existe crea una nueva version
    if (existDocument.size() > 0) {
      cVersion.ContentDocumentId = existDocument.get(0).ContentDocumentId;
      insert cVersion;
    } else {
      insert cVersion;
      Id documentId = [
        SELECT ContentDocumentId
        FROM ContentVersion
        WHERE Id = :cVersion.Id
      ]
      .ContentDocumentId;
      ContentDocumentLink documentLink = new ContentDocumentLink(
        LinkedEntityId = parentId,
        ContentDocumentId = documentId,
        shareType = 'V'
      );
      insert documentLink;
    }

    // ContentDistribution cd = new ContentDistribution();
    // cd.name = cVersion.Title;
    // cd.ContentVersionId = cVersion.id;
    // cd.PreferencesAllowOriginalDownload = true;
    // cd.PreferencesAllowPDFDownload = true;
    // cd.PreferencesAllowViewInBrowser = true;
    // insert cd;
    return cVersion;
  }

  public static String[] getContent(String idConstancia, String idContact) {
    Constancia__c constancia = [
      SELECT
        Name,
        Nombre__c,
        Contenido__c,
        Adjuntar__c,
        CriterioJson__c,
        IncluirModeloPrograma__c
      FROM Constancia__c
      WHERE Id = :idConstancia
    ];

    if (constancia.CriterioJson__c != null) {
      Boolean valido = CriteriaHelper.validateCriteria(
        constancia.CriterioJson__c,
        idContact
      );
      if (!valido) {
        throw new ApplicationException('No cumple los criterios');
      }
    }
    // Obtiene objectRecords segun las {} de Contenido__c y Nombre__c
    Map<String, SObject> objectRecords = new Map<String, SObject>{
      'constancia' => constancia
    };
    // TODO: Performance el query al contact y program podria hacerlo una vez y no dos
    Map<String, String> mapRecordId = getMapRecordId(idContact);
    // Obtiene Header y Footer del Programa
    Programa__c programa = [
      SELECT Header__c, Footer__c, PageHeader__c, PageFooter__c
      FROM Programa__c
      WHERE Id = :mapRecordId.get('programa')
    ];
    Map<String, Set<String>> mapFields = getMapFields(
      String.format(
        '{0} {1} {2} {3} {4} {5}',
        new List<String>{
          constancia.Nombre__c,
          constancia.Contenido__c,
          programa.Header__c,
          programa.Footer__c,
          programa.PageHeader__c,
          programa.PageFooter__c
        }
      )
    );
    for (String objeto : mapFields.keySet()) {
      if (objeto != 'formulas' && objeto != 'constancia') {
        String objectName = mapObjects.get(objeto);
        SObject record = UtilHelper.getRecordById(
          objectName,
          mapFields.get(objeto),
          mapRecordId.get(objeto)
        );
        objectRecords.put(objeto, record);
      }
    }
    // Merge content y titulo
    String content = mergeFields(constancia.Contenido__c, objectRecords);
    String titulo = mergeFields(constancia.Nombre__c, objectRecords);

    if (constancia.IncluirModeloPrograma__c) {
      String header = programa.Header__c == null
        ? ''
        : mergeFields(programa.Header__c, objectRecords);
      String footer = programa.Footer__c == null
        ? ''
        : mergeFields(programa.Footer__c, objectRecords);
      content = header + content + footer;
    }
    String pageHeader = programa.PageHeader__c == null
      ? ''
      : mergeFields(programa.PageHeader__c, objectRecords);
    String pageFooter = programa.PageFooter__c == null
      ? ''
      : mergeFields(programa.PageFooter__c, objectRecords);

    return new List<String>{ titulo, content, pageHeader, pageFooter };
  }

  @AuraEnabled
  public static ContentVersion generatePDF(
    String idConstancia,
    String idContact
  ) {
    // Query Data
    String[] content = getContent(idConstancia, idContact);
    // Genera el  PDF
    Pagereference pg = Page.RenderAsPDF;

    pg.getParameters().put('body', EncodingUtil.urlEncode(content[1], 'UTF-8'));
    if (content[2] != '') {
      pg.getParameters()
        .put('header', EncodingUtil.urlEncode(content[2], 'UTF-8'));
    }
    if (content[3] != '') {
      pg.getParameters()
        .put('footer', EncodingUtil.urlEncode(content[3], 'UTF-8'));
    }
    Blob pdf = Test.isRunningTest()
      ? Blob.valueOf(content[1])
      : pg.getContentAsPDF();

    // TODO: Validar si no es Adjuntar__c ?
    return attachDocument(content[0], pdf, idContact, 'pdf');
  }
}
