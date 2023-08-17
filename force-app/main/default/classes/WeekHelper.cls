public class WeekHelper {
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
}