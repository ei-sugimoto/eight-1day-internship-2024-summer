import { FC, useState } from "react";
import { Person } from "../apis/people";
import { AsyncCardImage } from "./AsyncCardImage";
import styles from "./CardListItem.module.css";
import { MemoEditDialog } from "./MemoEditDialog";
import { Button } from "./Button";
import { MemoViewer } from "./MemoViewer";

export const CardListItem: FC<{
  person: Person;
  onEditMemo: (personId: number, memo: string) => Promise<void>;
}> = ({ person, onEditMemo }) => {
  const [isOpen, setIsOpen] = useState(false);

  const onSave = async (memo: string) => {
    await onEditMemo(person.id, memo);
  };

  return (
    <div className={styles.root}>
      <div className={styles.cardArea}>
        <div className={styles.cardInfo}>
          <p className={styles.nameAndOrg}>
            <span className={styles.name}>{person.cards[person.cards.length - 1].name}</span>
            <span className={styles.organization}>
              {person.cards[person.cards.length - 1].organization}
            </span>
          </p>
          <div className={styles.memoArea}>
            <Button size="small" onClick={() => setIsOpen(true)}>
              メモの編集
            </Button>
            {/* React_Q3 名刺メモを表示しよう */}
            {person.memo ? (
              <div className={styles.memo}>
                <MemoViewer memo={person.memo || ""} />
              </div>
            ) : null}
          </div>
          {person.cards.length > 1 && (
            <p>他に{person.cards.length - 1}件名刺があります</p>
          )}
        </div>
        <div>
          <AsyncCardImage person={person} />
        </div>
      </div>
      {isOpen && (
        <MemoEditDialog
          initialMemo={person.memo || ""}
          onRequestClose={() => setIsOpen(false)}
          onSave={onSave}
        />
      )}
    </div>
  );
};
