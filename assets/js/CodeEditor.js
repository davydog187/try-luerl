import { StreamLanguage } from "@codemirror/language";
import { lua } from "@codemirror/legacy-modes/mode/lua";

import { EditorView, basicSetup } from "codemirror";

export const CodeEditor = {
  mounted() {
    const initialCode = this.el.dataset.code;

    let view = new EditorView({
      doc: initialCode,
      extensions: [
        basicSetup,
        StreamLanguage.define(lua),
        EditorView.updateListener.of((update) => {
          if (update.docChanged) {
            const newCode = update.state.doc.toString();
            this.pushEvent("code_updated", { code: newCode });
          }
        }),
      ],
      parent: this.el,
    });

    this.handleEvent("set_code", ({ code }) => {
      editor.dispatch({
        changes: { from: 0, to: editor.state.doc.length, insert: code },
      });
    });
  },
};
