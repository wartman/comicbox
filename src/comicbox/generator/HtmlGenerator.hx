package comicbox.generator;

import boxup.Outcome;
import boxup.Node;
import boxup.Generator;
// import boxup.Builtin;

using StringTools;

class HtmlGenerator implements Generator<String> {
  var pageCount = 0;
  var panelCount = 0;

  public function new() {}

  public function generate(nodes:Array<Node>):Outcome<String> {
    panelCount = 0;
    pageCount = 0;
    var body = generateNodes(nodes);
    return Ok(body.join(''));
  }

  function generateNodes(nodes:Array<Node>, wrapParagraph:Bool = true) {
    return nodes.map(n -> generateNode(n, wrapParagraph));
  }

  function generateNode(node:Node, wrapParagraph:Bool = true):String {
    return switch node.type {
      case Block('Comic'):
        el('header', [
          'class' => 'comic-header'
        ], [
          el('h1', [], [ node.getProperty('title') ]),
          el('h2', [], [ 'Author: ' + node.getProperty('author') ])
        ]);
      case Block('Page'):
        pageCount++;
        panelCount = 0;
        el('section', [ 'class' => 'page' ], generateNodes(node.children));
      case Block('Panel'):
        panelCount++;
        el('div', [ 'class' => 'panel' ], [
          el('header', [
            'class' => 'panel-header'
          ], [
            el('h3', [], [ 'Panel ${pageCount}.${panelCount}' ])
          ].concat(generateNodes(node.children)))
        ]);
      case Block('Dialog'):
        el('div', [
          'class' => 'dialog'
        ], [
          el('header', [ 'class' => 'dialog-character' ], [
            el('h4', [], [ node.getProperty('character') ])
          ])
        ].concat(generateNodes(node.children)));
      case Block('Item'):
        el('li', [], generateNodes(node.children, wrapParagraph));
      case Paragraph:
        node.children.map(n -> generateNode(n, false)).join('');
      case Text:
        node.textContent.htmlEscape();
      case Block(name):
        el('div', [ 'class' => name.toLowerCase() ], generateNodes(node.children, wrapParagraph));
    }
  }

  function el(tag:String, props:Map<String, String>, children:Array<String>) {
    var out = '<$tag';
    var props = [ for (key => value in props) 
      if (value != null) '$key="$value"' else null ].filter(v -> v != null);
    if (props.length > 0) out += ' ${props.join(' ')}';
    return if (children != null) 
      out + '>' + children.join('') + '</$tag>';
    else 
      out + '/>';
  }
}
