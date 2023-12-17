public with sharing class RenderAsPDFController {
  public String header { get; set; }
  public String body { get; set; }
  public String footer { get; set; }

  public RenderAsPDFController() {
    Map<String, String> params = ApexPages.currentPage().getParameters();
    if (params.get('header') != null) {
      header = EncodingUtil.urlDecode(params.get('header'), 'UTF-8');
    } else {
      header = '';
    }
    if (params.get('body') != null) {
      body = EncodingUtil.urlDecode(params.get('body'), 'UTF-8');
      System.debug(body);
    } else {
      body = '';
    }
    if (params.get('footer') != null) {
      // Page <span class="pagenumber"/> of <span class="pagecount"/>
      footer = EncodingUtil.urlDecode(params.get('footer'), 'UTF-8');
    } else {
      footer = '';
    }

    if (params.get('idConstancia') != null && params.get('idContact') != null) {
      String[] content = ConstanciaHelper.getContent(
        params.get('idConstancia'),
        params.get('idContact')
      );
      body = content[1];
      header = content[2];
      footer = content[3];
    }
  }
}
