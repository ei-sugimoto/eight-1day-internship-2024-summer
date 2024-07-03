import { FC } from "react";
import styles from "./MemoViewer.module.css";

const URL_PATTERN = /TODO/;

// React_Q3 メモの表示をリッチにしよう
export const MemoViewer: FC<{ memo: string }> = ({ memo }) => {
  return <div>{memo}</div>;
};
