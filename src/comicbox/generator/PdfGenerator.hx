package comicbox.generator;

import boxup.Builtin;
import boxup.Outcome;
import boxup.Node;
import boxup.Generator;
import pdfkit.PdfDocument;

using haxe.io.Path;

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
    var root = Sys.programPath().directory();

    doc.registerFont('Default', Path.join([ root, 'assets', 'fonts', 'CourierPrime-Regular.ttf' ]));
    doc.registerFont('Bold', Path.join([ root, 'assets', 'fonts', 'CourierPrime-Bold.ttf' ]));
    doc.registerFont('Italic', Path.join([ root, 'assets', 'fonts', 'CourierPrime-Italic.ttf' ]));

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
          .font('Bold', 20)
          .text(node.getProperty('title'), { align: 'center' })
          .moveDown(4)
          .font('Bold', 12)
          .text('Author: ${node.getProperty('author')}', { align: 'center' });

      case Block('Page'):
        pageCount++;
        panelCount = 0;

        doc
          .addPage()
          .font('Bold', 12)
          .text('PAGE ${pageCount}')
          .moveDown(2);
        
        generateNodes(node.children, doc, {});
      
      case Block('Panel'):
        panelCount++;
        doc
          .font('Bold', 12)
          .text('Panel ${pageCount}.${panelCount}'.toUpperCase())
          .moveDown();
        generateNodes(node.children, doc, {});
        doc.moveDown();

      case Block('Dialog'):
        doc
          .moveDown()
          .text(node.getProperty('character').toUpperCase(), {
            align: 'center'
          });

        // todo: we need to center things better.
        generateNodes(node.children, doc, {
          align: 'center'
        });

      case Block('Sfx'):
        doc
          .moveDown()
          .text('SFX (' + node.getProperty('note', 'sound') + ')', {
            align: 'center'
          });
        
        generateNodes(node.children, doc, {
          align: 'center'
        });

      case Block('Attached'):
        doc.text('(attached) ', style);

        generateNodes(node.children, doc, style);
      
      case Paragraph:
        // For now we're ignoreing bold/italic/etc
        var text:Array<String> = [];
        for (child in node.children) switch child.type {
          case Text: text.push(child.textContent);
          case Block(BItalic) | Block(BBold) | Block(BUnderlined):
            for (c in child.children) switch c.type {
              case Text: text.push(c.textContent);
              default: // hm
            }
          default: // hm
        }

        doc
          .font('Default', 12)
          .text(text.join(''), style);

        doc.moveDown();

      case Block(BItalic) | Block(BBold) | Block(BUnderlined):
        generateNodes(node.children, doc, style);

      case Text:
        doc.text(node.textContent, style);
      
      default:
        // skip
    }
  }
}
