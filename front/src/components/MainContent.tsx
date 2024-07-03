import styles from "./MainContent.module.css";
import { FC } from "react";
import { usePeople } from "../utils/useData";
import { CardList } from "./CardList";
import { SearchField } from "./SearchField";

export const MainContent: FC = () => {
  const {
    isLoading,
    data: people,
    error,
    search,
    fetchMore,
    hasMore,
    updateMemo,
  } = usePeople();

  const onEditMemo = async () => {
    // TODO
  };

  return (
    <div className={styles.root}>
      <h1>People</h1>
      <div className={styles.content}>
        <SearchField onRequestSearch={search} />
        {isLoading ? (
          <p>Loading...</p>
        ) : error ? (
          <p>Error: {error.message}</p>
        ) : (
          <CardList
            people={people}
            onEditMemo={onEditMemo}
            onRequestMore={fetchMore}
            hasMore={hasMore}
          />
        )}
      </div>
    </div>
  );
};
