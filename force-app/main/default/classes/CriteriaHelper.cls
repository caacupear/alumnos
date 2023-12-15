/**
 *  
 Ejemplos:
    A) Math ALL (operator default son "and" e "==")
    { 
        terms: [ {"field": "field1", "value": "value1"}, {"field": "field2", "value": "value2" } ]
    }
    equivale a: (field1 == value1 AND field2 == value2)
    B) Math ANY  (operator or o any son sinonimos)
    { 
        terms: [ {"field": "field1", "value": "value1"}, {"field": "field2", "value": "value2" } ]
        operator: "or"
    }
    equivale a: (field1 == value1 OR field2 == value2)

    C) Custom 
    { 
        terms: [ { terms: [...]  }, {"field": "field3", value: "value3" } ]
    }
    equivale a: (field1 == value1 OR field2 == value2) AND field3 == value3

 */

public with sharing class CriteriaHelper {
  public static Boolean validateCriteria(String criteria, String idContact) {
    CriteriaEngine engine = new CriteriaEngine(criteria, idContact);

    return engine.evaluate();
  }

  private class CriteriaEngine {
    private CriteriaTerms root;
    private Contact contact;
    private Set<String> fields;

    private CriteriaTerms processCriteria(Map<String, Object> element) {
      CriteriaTerms base = new CriteriaTerms((String) element.get('operator'));
      if (element.containsKey('terms')) {
        for (Object term : (List<Object>) element.get('terms')) {
          Map<String, Object> mapTerm = (Map<String, Object>) term;

          if (mapTerm.containsKey('field')) {
            String field = (String) mapTerm.get('field');
            fields.add(field);
            base.terms.add(
              new CriteriaTerm(
                field,
                mapTerm.get('value'),
                (String) mapTerm.get('operator')
              )
            );
          } else if (element.containsKey('terms')) {
            // Si es recursivo
            base.terms.add(processCriteria(mapTerm));
          }
        }
      }
      return base;
    }

    public CriteriaEngine(String criteria, String idContact) {
      fields = new Set<String>();
      root = processCriteria(
        (Map<String, Object>) JSON.deserializeUntyped(criteria)
      );
      this.contact = (Contact) UtilHelper.getRecordById(
        'Contact',
        fields,
        idContact
      );
    }

    public Boolean evaluate() {
      return root.evaluate(contact);
    }
  }

  private interface BooleanExpression {
    Boolean evaluate(SObject record);
  }

  private class CriteriaTerms implements BooleanExpression {
    public BooleanExpression[] terms;
    public String operator = 'and';

    public CriteriaTerms(String operator) {
      this.terms = new List<BooleanExpression>();
      if (operator != null) {
        this.operator = operator;
      }
    }

    private Boolean evaluateAll(SObject record) {
      for (BooleanExpression criteria : terms) {
        if (!criteria.evaluate(record)) {
          return false;
        }
      }
      return true;
    }
    private Boolean evaluateAny(SObject record) {
      for (BooleanExpression criteria : terms) {
        if (criteria.evaluate(record)) {
          return true;
        }
      }
      return false;
    }
    public Boolean evaluate(SObject record) {
      Boolean retVal;
      switch on operator.toLowerCase() {
        when 'or', 'any' {
          retVal = evaluateAny(record);
        }
        when else {
          retVal = evaluateAll(record);
        }
      }
      return retVal;
    }
  }

  private class CriteriaTerm implements BooleanExpression {
    public String field;
    public Object value;
    public String operator = '=';

    public CriteriaTerm(String field, Object value, String operator) {
      this.field = field;
      this.value = value;
      if (operator != null) {
        this.operator = operator;
      }
    }

    public Boolean evaluate(SObject record) {
      Boolean retVal;
      String typeField = getBaseType(record.get(field));
      String typeValue = getBaseType(value);
      switch on operator {
        when '<>', '!=' {
          retVal = record.get(field) !== value;
        }
        when '>' {
          if (typeField == 'Number' && typeValue == 'Number') {
            retVal = (Double) record.get(field) > (Double) value;
          }
        }
        when '>=' {
          if (typeField == 'Number' && typeValue == 'Number') {
            retVal = (Double) record.get(field) >= (Double) value;
          }
        }
        when '<=' {
          if (typeField == 'Number' && typeValue == 'Number') {
            retVal = (Double) record.get(field) <= (Double) value;
          }
        }
        when '<' {
          if (typeField == 'Number' && typeValue == 'Number') {
            retVal = (Double) record.get(field) < (Double) value;
          }
        }
        when else {
          retVal = record.get(field) == value;
        }
      }
      return retVal;
    }
  }

  private static String getBaseType(Object o) {
    if (o instanceof Boolean)
      return 'Boolean';
    if (o instanceof Date)
      return 'Date';
    if (o instanceof Datetime)
      return 'Datetime';
    if (o instanceof Time)
      return 'Time';
    if (o instanceof Integer)
      return 'Number';
    if (o instanceof Long)
      return 'Number';
    if (o instanceof Decimal)
      return 'Number';
    if (o instanceof Double)
      return 'Number';
    return 'String';
  }
}
