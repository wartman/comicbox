package comicbox.render;

import boxup.Compiler;
import boxup.cli.DefaultReporter;
import comicbox.definition.ComicboxValidator;
import comicbox.generator.PdfGenerator;
import comicbox.generator.PdfGeneratorStream;

class RenderCompiler extends Compiler<PdfGeneratorStream> {
  public function new(validator:ComicboxValidator) {
    super(
      new DefaultReporter(),
      new PdfGenerator(),
      validator
    );
  }
}
