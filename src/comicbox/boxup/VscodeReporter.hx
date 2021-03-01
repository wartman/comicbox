package comicbox.boxup;

import boxup.ErrorCollection;
import boxup.Reporter;
import boxup.Source;
import comicbox.provider.DiagnosticsProvider;

using comicbox.Util;

class VscodeReporter implements Reporter {
  final diagnostics:DiagnosticsProvider;
  
  public function new(diagnostics) {
    this.diagnostics = diagnostics;
  }

  public function report(errors:ErrorCollection, source:Source):Void {
    diagnostics.report(errors);
  }
}
