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
      case 'updateHtml':
        target.innerHTML = message.content;
      case 'updateState':
        const incoming = message.state;
        if (incoming.uri != undefined) {
          state.uri = incoming.uri;
        }
        vscode.setState(state);
    }
  });
})();
