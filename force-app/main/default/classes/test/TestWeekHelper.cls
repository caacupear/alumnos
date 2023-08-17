@IsTest
public class TestWeekHelper {
    @IsTest
    static void testHelper(){
        Date fistDate = Date.newInstance(Date.today().year() -5, 1, 1);
        
        for ( Integer i = 0; i < 365*10; i++ ) {
            Date dateIndex = fistDate.addDays(i);
            Integer weekDate = WeekHelper.getWeekOfDate(dateIndex);
            System.debug(i + ' ' + weekDate + ' ' + dateIndex + ' ' + dateIndex.toStartofWeek().year());
            System.assertEquals(dateIndex.toStartOfWeek(), WeekHelper.getFirsDateOfWeek(weekDate, dateIndex.toStartofWeek().year() ) );
        }
    }

}