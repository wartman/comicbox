package comicbox.boxup;

import boxup.Reporter;
import boxup.Error;
import boxup.Source;
import comicbox.provider.DiagnosticsProvider;

using comicbox.Util;

class VscodeReporter implements Reporter {
  final diagnostics:DiagnosticsProvider;
  
  public function new(diagnostics) {
    this.diagnostics = diagnostics;
  }

  public function report(errors:Array<Error>, source:Source):Void {
    diagnostics.report(errors);
  }
}
