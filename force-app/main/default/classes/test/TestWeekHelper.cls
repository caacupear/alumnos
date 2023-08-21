@IsTest
public class TestWeekHelper {
    @IsTest
    static void testWeekOfDateContoStartofWeek(){
        Date fistDate = Date.newInstance(Date.today().year() -5, 1, 1);
        
        for ( Integer i = 0; i < 365*10; i++ ) {
            Date dateIndex = fistDate.addDays(i);
            Integer weekDate = WeekHelper.getWeekOfDate(dateIndex);
            System.debug(i + ' ' + weekDate + ' ' + dateIndex + ' ' + dateIndex.toStartofWeek().year());
            System.assertEquals(dateIndex.toStartOfWeek(), WeekHelper.getFirsDateOfWeek(weekDate, dateIndex.toStartofWeek().year() ) );
        }
    }

    @IsTest
    static void testListaDeSemanas(){
        Date desde = Date.newInstance(2001, 1, 1);
        Date hasta = Date.newInstance(2001, 2, 1);        
        List<WeekHelper.Semana> semanas = WeekHelper.getWeeksRange(desde, hasta);
        Integer index = 1;
        for ( WeekHelper.Semana semana: semanas) {
            System.assertEquals(semana.numero, index);
            System.assertEquals(semana.desde, desde);
            desde.addDays(7);
            index++;
        }
    }
}