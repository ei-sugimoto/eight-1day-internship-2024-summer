import { FC } from "react";
import { Person } from "../apis/people";
import { CardListItem } from "./CardListItem";
import styles from "./CardList.module.css";
import { Loader } from "./Loader";

export const CardList: FC<{
  people: Person[];
  onEditMemo: (personId: number, memo: string) => Promise<void>;
  onRequestMore: VoidFunction;
  hasMore: boolean;
}> = ({ people, onEditMemo, onRequestMore, hasMore }) => {
  return (
    <section className={styles.root}>
      <ul className={styles.list}>
        {people.map((person) => (
          <li key={person.cards[person.cards.length - 1].id} className={styles.itemContainer}>
            <CardListItem person={person} onEditMemo={onEditMemo} />
          </li>
        ))}
      </ul>
      {hasMore && <Loader onVisible={onRequestMore} />}
    </section>
  );
};
