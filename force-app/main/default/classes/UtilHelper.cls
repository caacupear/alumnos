public with sharing class UtilHelper {
  public static SObject getRecordById(
    String objectName,
    Set<String> fields,
    String idRecord
  ) {
    String query =
      'SELECT ' +
      String.join(fields, ',') +
      ' From ' +
      objectName +
      ' WHERE Id = :idRecord';
    System.debug(query);
    SObject record = Database.query(query);
    return record;
  }
}
