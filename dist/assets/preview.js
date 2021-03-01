(function () {
  const vscode = acquireVsCodeApi();
  const previousState = vscode.getState();
  const target = document.getElementById('target');
  var state = {
    uri: ''
  };

  if (previousState != undefined) {
    state = previousState;
  }

  window.addEventListener('message', event => {
    const message = event.data;
    switch (message.command) {
      case 'update':
        target.innerHTML = message.content;
      case 'setState':
        if (message.uri != undefined) {
          state.uri = message.uri;
        }
        vscode.setState(state);
    }
  });
})();
