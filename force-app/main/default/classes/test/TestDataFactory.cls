// TODO: Que puedan las relaciones estar tambien en memoria

public class TestDataFactory {    
    static final Boolean DEFAULT_INSERT = true;
    static final Integer DEFAULT_RECORDS = 3;

    static private Map<String,Division__c> divisiones;
    static private Map<String,Contact> alumnos;
    static private Map<String,Contact> docentes;
    static private Map<String, Asistencia__c> asistencias;
    static private Map<String, Boletin__c> boletines;
    static private Map<String, Grilla__c> grilla;
    static private Map<String, CicloLectivo__c> ciclos; 
    static private Map<String, Evaluacion__c> evaluaciones;
    static private Map<String, ProgramaEvaluacion__c> programaEvaluaciones;
    static private Map<String,Programa__c> programas;
    static private Map<String, Materia__c> materias;

    
    private static void resolverId(List<SObject> objects, String relation, String field ) {
        for ( SObject o: objects){
            o.put(field, o.getSObject(relation).get('Id'));
        }
    }
    private static String getName(String prefix, Integer index, Map<String, SObject> mp) {
        return getName(prefix, index, mp.size() );
    }
    private static String getName(String prefix, Integer index, Integer max) {
        return getName( prefix, Math.mod(index, max));
    }
    private static String getName(String prefix, Integer index) {
        if ( !prefix.contains('{0}')) prefix = prefix + '-{0}'; 
        return String.format(prefix, new List<Object> { index} );        
    }
    
    public static void makeMaterias(Boolean insertValues, Integer qty) {
        materias = new Map<String, Materia__c>();

        for( Integer index = 0; index < qty; index++ ) {
            String name = getName('M', index);
            materias.put( name, new Materia__c( Name = name, anoEscolar__c = Math.Mod(index, 5) ) );
        }
        if ( insertValues ) {
            insert materias.values();
        }
    }

    public static Map<String, Materia__c> getMaterias(){
        if ( materias == null ) {
            makeMaterias(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return materias;
    }

    public static void makeProgramas(Boolean insertValues, Integer qty) {
        programas = new Map<String, Programa__c>();
        
        for( Integer index = 0; index < qty; index++ ) {
            String name = getName('P', index);
            programas.put( name, new Programa__c( Name = name ) );
        }
        if ( insertValues ) {
            insert programas.values();
        }
    }

    static public Map<String, Programa__c> getProgramas(){
        if ( programas == null ) {
            makeProgramas(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return programas;
    }

    public static Map<String, ProgramaEvaluacion__c> getProgramaEvaluaciones(){
        if ( programaEvaluaciones == null ) {
            makeProgramaEvaluaciones(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return programaEvaluaciones;
    }

    public static void makeProgramaEvaluaciones( Boolean insertValues, Integer qty){
        programaEvaluaciones = new Map<String, ProgramaEvaluacion__c>(); 

        Integer index = 1, i = 1;
        while ( qty > 0 ){
            Programa__c programa = getProgramas().get( getName('P', index++) );
            
            programaEvaluaciones.put( getName('P', index++), new ProgramaEvaluacion__c( Programa__c = programa.Id,  Tipo__c = 'Nota', Campo__c = 'Nota1__c'));
            programaEvaluaciones.put( getName('P', index++), new ProgramaEvaluacion__c( Programa__c = programa.Id,  Tipo__c = 'Nota', Campo__c = 'Nota2__c'));
            programaEvaluaciones.put( getName('P', index++), new ProgramaEvaluacion__c( Programa__c = programa.Id,  Tipo__c = 'Nota', Campo__c = 'Nota3__c'));
            qty = qty -3;
        }
         
        if( insertValues ) {
            insert programaEvaluaciones.values();
        } 
    }    

    public static Map<String, Evaluacion__c> getEvaluaciones(){
        if ( evaluaciones == null ) {
            makeEvaluaciones(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return evaluaciones;
    }

    public static void makeEvaluaciones( Boolean insertValues, Integer qty){
        evaluaciones = new Map<String, Evaluacion__c>();
       
        for( Integer index = 0; index < qty; index++ ) {
            
            Boletin__c boletin = getBoletines().get(getName('B', index, boletines));
            Grilla__c grilla = getGrilla().get(getName('G', index, grilla));
    
            evaluaciones.put( 'B-' + index + ' G-' + index, new Evaluacion__c( Boletin__c =boletin.Id, Grilla__c = grilla.id, Nota1__c = 10) );
        }
        
        if( insertValues ) {
            insert evaluaciones.values();
            system.debug(evaluaciones.values().size());
        } 
    }

    static public Map<String, CicloLectivo__c> getCiclos(){
        if ( ciclos == null) {
            makeCiclos(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return ciclos;
    }

    public static void makeCiclos( Boolean insertValues, Integer qty){
        ciclos = new Map<String, CicloLectivo__c>();
        Integer index = 1;
        while ( qty > 0 ){
            Programa__c programa = getProgramas().get('P-' + index);
            ciclos.put( getName('CP', index), new CicloLectivo__c( Name = 'CP-' + index, Programa__c = programa.Id, Inicio__c = Date.Today().addDays(-540), Fin__c = Date.Today().addDays(-181) ) );
            ciclos.put( getName('CA', index), new CicloLectivo__c( Name = 'CA-' + index, Programa__c = programa.Id, Inicio__c = Date.Today().addDays(-180), Fin__c = Date.Today().addDays(180) ) );
            ciclos.put( getName('CF', index), new CicloLectivo__c( Name = 'CF+' + index, Programa__c = programa.Id, Inicio__c = Date.Today().addDays(181), Fin__c = Date.Today().addDays(540) ) );
            qty = qty -3;
            index++;
        }
        if( insertValues ) {
            insert ciclos.values();
        }
    }

    public static Map<String, Grilla__c> getGrilla(){
        if ( grilla == null ) {
            makeGrilla(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return grilla;
    }

    public static void makeGrilla( Boolean insertValues, Integer qty){    
        grilla = new Map<String, Grilla__c>();
        List<GrillaHorario__c> horarios = new List<GrillaHorario__c>();
        
        for( Integer index = 0; index < qty; index++ ) { 
            Division__c division = getDivisiones().get( getName('D', index, divisiones) );
            Materia__c materia = getMaterias().get( getName('M', index, materias));
            Contact docente = getDocentes().get( getName('D', index, docentes));
            String name = getName('G', index);
            grilla.put( name, new Grilla__c( Materia__c = materia.Id, Docente__c = docente.Id, Division__c = division.Id ) );
            System.debug(grilla.get(name));
            horarios.add( new GrillaHorario__c( Grilla__r = grilla.get(name), dia__c = 'Lunes', desde__c = Time.newInstance(10, 0,0,0), hasta__c =Time.newInstance(11, 0,0,0)) ); 
        }

        if( insertValues ) {
            insert grilla.values();
            resolverId(horarios, 'Grilla__r', 'Grilla__c'); 
            insert horarios;
        }
    }

    public static Map<String, Boletin__c> getBoletines(){
        if ( boletines == null ) {
            makeBoletines(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return boletines;
    }

    public static void makeBoletines( Boolean insertValues, Integer qty){    
        boletines = new Map<String, Boletin__c>();

        for( Integer index = 0; index < qty; index++ ) { 
            Division__c division = getDivisiones().get( getName('D', index, 2) );
            Contact alumno = getAlumnos().get(getName('A', index, alumnos) );

            boletines.put( getName('B', index), new Boletin__c( Division__c = division.Id, Alumno__c = alumno.Id) );
        }

        if( insertValues ) {
            insert boletines.values();
        }
    }

    public static Map<String, Asistencia__c> getAsistencias(){
        if ( asistencias == null ) {
            makeAsistencias(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return asistencias;
    }
    
    public static void makeAsistencias( Boolean insertValues, Integer qty){
        asistencias = new Map<String, Asistencia__c>();

        Integer index = 1;
        while ( qty > 0 ){
            Boletin__c boletin = getBoletines().get( getName('B', index, boletines) );
            asistencias.put( getName('B-{0} S-1', index), new Asistencia__c( Boletin__c =boletin.Id, Semana__c = 1, Lunes__c = 'Asistio', Martes__c = 'Asistio', Miercoles__c = 'Asistio', Jueves__c = 'Asistio', Viernes__c = 'Asistio') );
            asistencias.put( getName('B-{0} S-2', index), new Asistencia__c( Boletin__c =boletin.Id, Semana__c = 2, Lunes__c = 'Tarde', Martes__c = 'Asistio', Miercoles__c = 'Asistio', Jueves__c = 'Asistio', Viernes__c = 'Asistio') );
            qty = qty-2;
        }

        if( insertValues ) {
            insert asistencias.values();
            system.debug(asistencias.values().size());
        } 
    }
    
    static public Map<String, Division__c> getDivisiones(){
        if ( divisiones == null ) {
            makeDivisiones(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return divisiones;
    }

    public static void makeDivisiones( Boolean insertValues, Integer qty){
        divisiones = new Map<String, Division__c>();
        
        for( Integer index = 0; index < qty; index++ ) { 
            CicloLectivo__c ciclo = getCiclos().get('CA-1');    
            divisiones.put( getName('D', index ), new Division__c( CicloLectivo__c = ciclo.Id, anoEscolar__c = Math.Mod(index,5), subdivision__c = String.valueOf(index) ) );
        }

        if( insertValues ) {
            insert divisiones.values();
        }
    }


    static public Map<String,Contact> getAlumnos(){
        if  (alumnos == null ) {
            makeAlumnos(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return alumnos;
    }

    public static void makeAlumnos( Boolean insertValues, Integer qty){
        alumnos = new Map<String,Contact>();
        
        for( Integer index = 0; index < qty; index++ ) { 
            alumnos.put( getName('A', index), new Contact( FirstName = 'First' + index ,LastName= 'Last' + index , recordTypeId = ContactHelper.getRecordTypeIdForAlumno(), Documento__c = '123' + index, TipoDeDocumento__c = 'DNI' ) );
        }

        if( insertValues ) {
            insert alumnos.values();
        }
    }

    static public Map<String,Contact> getDocentes(){
        if  (docentes == null ) {
            makeDocentes(DEFAULT_INSERT, DEFAULT_RECORDS);
        }
        return docentes;
    }

    public static void makeDocentes( Boolean insertValues, Integer qty){
        docentes = new Map<String,Contact>();
        for( Integer index = 0; index < qty; index++ ) { 
            docentes.put( getName('D', index), new Contact( FirstName = 'First' + index ,LastName= 'Last' + index , recordTypeId = ContactHelper.getRecordTypeIdForDocente(), Documento__c = '321' + index, TipoDeDocumento__c = 'DNI' ) );
        }

        if( insertValues ) {
            insert docentes.values();
        }
    }

}