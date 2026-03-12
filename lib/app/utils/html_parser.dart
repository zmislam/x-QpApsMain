import 'package:html/parser.dart' as html_parser;

// Function to parse and clean HTML tags
String parseHtmlString(var htmlString) {
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? '';
}

String buildDynamicTableRowsForDescription(var description) {
    
    StringBuffer htmlBuffer = StringBuffer();

    htmlBuffer.writeln('''
      <tr>
        // ignore: unnecessary_brace_in_string_interps
        <td style="text-align: left; padding: 8px;  font-weight: bold;">$description</td>
      </tr>
    ''');

    return htmlBuffer.toString();
  }

    String _buildDynamicTableRowsForSpecification(List specifications) {
  
    StringBuffer htmlBuffer = StringBuffer();

    for (var spec in specifications) {
      htmlBuffer.writeln('''
      <tr>
        <td style="text-align: left; padding: 8px; font-weight: bold;">${spec.label ?? ''}</td>
        <td style="text-align: left; padding: 8px;">${spec.value ?? 'N/A'}</td>
      </tr>
    ''');
    }

    return htmlBuffer.toString();
  }