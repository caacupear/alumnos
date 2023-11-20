public class WeekHelper {
    static Map<Integer, String> labelMeses = new Map<Integer, String>{ 1 => 'Enero', 2=>'Febrero', 3=>'Marzo', 4=>'Abril', 5=>'Mayo',6=>'Junio', 7=>'Julio', 8=>'Agosto', 9=>'Septiembre',10=>'Octubre', 11=>'Noviembre', 12=>'Diciembre' };

    public static Date getFirsDateOfWeek(Integer semana){
        return getFirsDateOfWeek(semana, Date.Today().year() );
    }

    public static Date getFirsDateOfWeek(Integer semana, Integer year) {
        Date firstDayOfYear = Date.newInstance( year, 1, 1);
        Date startWeek = firstDayOfYear.toStartofWeek();
        return firstDayOfYear == startWeek ? firstDayOfYear.addDays( (semana -1)* 7): startWeek.addDays(semana * 7);
    }

    public static Integer getWeekOfDate() {
        return getWeekOfDate(Date.Today());
    }

    public static Integer getWeekOfDate(Date fecha) {
        return Math.floor((fecha.toStartofWeek().dayOfYear() -1) / 7).intValue() +1;
    }

    public static String getWeekRangeLabel(Integer semana, Integer ano) {
        Date desde = getFirsDateOfWeek(semana, ano);
        return getWeekRangeLabel(desde, desde.addDays(4));
    }

    public static String getWeekRangeLabel(Date desde, Date hasta) {
        String label =  '#' + String.valueOf(getWeekOfDate(desde)) + ': ' + String.valueOf(desde.day());
        if ( desde.month() <> hasta.month()) {
            label += ' de ' + labelMeses.get(desde.month());
        }
        label += ' al ' + String.valueOf(hasta.day()) + ' de ' + labelMeses.get(hasta.month()); 
        if ( hasta.year() != Date.today().year() ) {
            label += ' del ' + hasta.year();
        }
        return label;
    }

    public static List<Semana> getWeeksRange(Date desde, Date hasta) {
        List<Semana> semanas = new List<Semana>();
        
        Date index = desde.toStartOfWeek();
        while ( index < hasta ) {
            Integer numero = getWeekOfDate(index);
            Date indexHasta = index.addDays(4);
            String label = getWeekRangeLabel(index, indexHasta);
            semanas.add( new Semana(numero, index, indexHasta, label));
            index = index.addDays(7);
        }
        return semanas;
    }

    public class Semana {
        @AuraEnabled public Integer numero;
        public Date desde;
        public Date hasta;
        @AuraEnabled public String label; 

        public Semana(Integer numero, Date desde, Date hasta, String label) {
            this.numero = numero;
            this.desde = desde;
            this.hasta = hasta;
            this.label = label;

        }
    }
}