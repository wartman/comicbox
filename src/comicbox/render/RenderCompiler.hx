package comicbox.render;

import boxup.Compiler;
import boxup.Validator;
import boxup.cli.DefaultReporter;
import comicbox.generator.PdfGenerator;
import comicbox.generator.PdfGeneratorStream;

class RenderCompiler extends Compiler<PdfGeneratorStream> {
  public function new(validator:Validator) {
    super(
      new DefaultReporter(),
      new PdfGenerator(),
      validator
    );
  }
}
