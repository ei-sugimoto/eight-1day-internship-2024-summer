import styles from "./Header.module.css";

import { FC } from "react";

export const Header: FC = () => {
  return (
    <header className={styles.root}>
      <a href="/" className={styles.logo}>
        Seven
      </a>
      <nav className={styles.nav}>
        <ul className={styles.list}>
          <li className={styles.item}>
            <a href="card_uploads/new" className={styles.link}>
              名刺取り込み
            </a>
          </li>
        </ul>
      </nav>
    </header>
  );
};
