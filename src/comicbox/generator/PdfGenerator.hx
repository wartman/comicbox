package comicbox.generator;

import boxup.Outcome;
import boxup.Node;
import boxup.Generator;
import pdfkit.PdfDocument;

class PdfGenerator implements Generator<PdfGeneratorStream> {
  var pageCount = 0;
  var panelCount = 0;

  public function new() {}
  
  public function generate(nodes:Array<Node>):Outcome<PdfGeneratorStream> {
    panelCount = 0;
    pageCount = 0;

    var doc = new PdfDocument({
      compress: false,
      size: 'LETTER',
      margins: {
        top: 30,
        left: 20,
        bottom: 30,
        right: 20
      }
    });
    var buffer = new PdfGeneratorStream();
    
    doc.pipe(buffer);
    generateNodes(nodes, doc, {});
    doc.end();

    return Ok(buffer);
  }

  function generateNodes(nodes:Array<Node>, doc:PdfDocument, style:PdfTextOptions) {
    for (node in nodes) generateNode(node, doc, style);
  }

  function generateNode(node:Node, doc:PdfDocument, style:PdfTextOptions) {
    switch node.type {
      case Block('Comic'):
        doc.info.title = node.getProperty('title');
        doc.info.author = node.getProperty('author');

        doc
          .text(node.getProperty('title'), { align: 'center' })
          .moveDown()
          .moveDown()
          .text('Author: ${node.getProperty('author')}', { align: 'center' });

      case Block('Page'):
        pageCount++;
        panelCount = 0;

        doc.addPage();
        
        generateNodes(node.children, doc, style);
      
      case Block('Panel'):
        panelCount++;
        doc
          .text('Panel ${pageCount}.${panelCount}'.toUpperCase())
          .moveDown();
        generateNodes(node.children, doc, style);
        doc.moveDown();

      case Block('Dialog'):
        doc
          .moveDown()
          .text(node.getProperty('character').toUpperCase(), {
            align: 'center'
          });

        generateNodes(node.children, doc, {
          align: 'center'
        });

      case Block('Sfx'):
        doc
          .moveDown()
          .text(node.getProperty('note', 'Sfx').toUpperCase(), {
            align: 'center'
          });
        
        generateNodes(node.children, doc, {
          align: 'center'
        });

      case Block('Attached'):
        doc
          .moveDown()
          .text('(attached)', style)
          .moveDown();

        generateNodes(node.children, doc, style);
      
      case Paragraph:
        generateNodes(node.children, doc, style);
        doc.moveDown();

      case Text:
        doc.text(node.textContent, style);
      
      default:
        // skip
    }
  }
}
