import { FC } from "react";
import styles from "./AsyncCardImage.module.css";
import { Person } from "../apis/people";

// React_Q1: 名刺画像を表示しよう
export const AsyncCardImage: FC<{ person: Person }> = ({ person }) => {
  return (
    <img
      className={styles.root}
    />
  );
};
