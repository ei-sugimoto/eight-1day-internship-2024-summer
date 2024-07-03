import { Button } from "./Button";
import styles from "./SearchField.module.css";
import { FC } from "react";
import { useDebouncedFunc } from "../utils/useDebouncedFunc";

// React_Q4 検索の通信を間引きましょう
export const SearchField: FC<{
  onRequestSearch: (text: string) => void;
}> = ({ onRequestSearch }) => {
  // const debouncedOnRequestSearch = useDebouncedFunc(onRequestSearch);

  return (
    <form
      className={styles.root}
      onSubmit={(e) => {
        e.preventDefault();
        const text = e.currentTarget.querySelector("input")?.value || "";
        onRequestSearch(text);
      }}
    >
      <input type="search" className={styles.input} name="keyword" />
      <Button type="submit">検索</Button>
    </form>
  );
};
