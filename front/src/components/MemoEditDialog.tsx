import { FC, useEffect, useState } from "react";
import { createPortal } from "react-dom";
import styles from "./MemoEditDialog.module.css"; // Import the styles module
import { Button } from "./Button";

// React_x_Rails_Q4: メモを登録・編集できるようにしよう
export const MemoEditDialog: FC<{
  initialMemo: string;
  onRequestClose: () => void;
  onSave: (memo: string) => Promise<void>;
}> = ({ initialMemo, onRequestClose }) => {
  const [memoText, setMemoText] = useState(initialMemo);
  const [error, setError] = useState("");

  const onChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setMemoText(e.target.value);
    setError("");
  };

  const handleOnClickSave = async () => {
    // TODO
  };

  useEffect(() => {
    document.getElementById("root")?.setAttribute("inert", "");
    return () => {
      document.getElementById("root")?.removeAttribute("inert");
    };
  }, []);

  return createPortal(
    <dialog className={styles.dialog} open={true}>
      <div className={styles.dialogContent}>
        <h2>メモの編集</h2>
        <div className={styles.editorBlock}>
          <textarea
            className={styles.memoEditor}
            defaultValue={memoText}
            onChange={onChange}
            autoFocus
          />
          <div className={styles.error}>{error}</div>
        </div>
        <div className={styles.buttonArea}>
          <Button onClick={onRequestClose} variant="secondary">
            キャンセル
          </Button>
          <Button onClick={handleOnClickSave} variant="primary">
            保存
          </Button>
        </div>
      </div>
    </dialog>,
    document.body
  );
};
