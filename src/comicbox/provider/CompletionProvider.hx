package comicbox.provider;

import haxe.extern.EitherType;
import vscode.CompletionList;
import vscode.CompletionItem;
import vscode.ProviderResult;
import vscode.CompletionContext;
import vscode.CancellationToken;
import vscode.Position;
import vscode.TextDocument;
import vscode.CompletionItemProvider;

class CompletionProvider {
  public static function create(documents, definitions):CompletionItemProvider<ComicBoxCompletionItem> {
    return new CompletionProvider(documents, definitions);
  }

  final documents:DocumentProvider;
  final definitions:DefinitionProvider;

  public function new(documents, definitions) {
    this.documents = documents;
    this.definitions = definitions;
  }

  public function provideCompletionItems(
    document:TextDocument, 
    position:Position, 
    token:CancellationToken,
    context:CompletionContext
  ):ProviderResult<EitherType<Array<ComicBoxCompletionItem>, CompletionList<ComicBoxCompletionItem>>> {
    var nodes = documents.getDocument(document.uri.toString());
    var completes:Array<ComicBoxCompletionItem> = [];
    switch definitions.getDefinitionFromNodes(nodes) {
      case None:
        // @todo: Give the option for a `[Note]` or a `[Comic]`
      case Some(definition):
        // @todo: check through defined nodes and see if any match up?
        //        If we are in a matching blok, we can provide `Child` completeions
        //        (if we're in a block context) or property completions (if
        //        we're in that context). Should be automatic, more or less.
    }

    return null;
  }

  public function resolveCompletionItem(item:ComicBoxCompletionItem, token:CancellationToken):ProviderResult<ComicBoxCompletionItem> {
    return null;
  }
}

class ComicBoxCompletionItem extends CompletionItem {}