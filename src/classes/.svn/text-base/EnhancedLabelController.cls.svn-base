public class EnhancedLabelController {

  public String tooltip { get; set; }
  public String forField { get; set; }
  public String label { get; set; }
  public Boolean renderIcon { get; set; }


  public String getOnLoad() {
    
    if(tooltip != null && tooltip != '')
        return '' +
    '<script type="text/javascript">\n' + 
    '        $(function() { \n' +
    '           $("#La' + forField + '").tooltip({\n' + 
    '               track: true, \n' + 
    '               delay: 0, \n' + 
    '               showURL: false, \n' + 
    '               showBody: " - ", \n' + 
    '               extraClass: "pretty", \n' + 
    '               fixPNG: true, \n' + 
    '               opacity: 0.95, \n' + 
    '               left: -120 \n' + 
    '           });\n' + 
    '      });\n' +
    '</script>';
    
    return '';
  }

}