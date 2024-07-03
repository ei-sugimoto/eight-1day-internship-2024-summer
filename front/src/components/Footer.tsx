import styles from "./Footer.module.css";

import { FC } from "react";

export const Footer: FC = () => {
  return <footer className={styles.root}>{"© Sansan, Inc."}</footer>;
};
