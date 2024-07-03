import styles from "./TopPage.module.css";

import { FC } from "react";

import { Header } from "../components/Header";
import { Footer } from "../components/Footer";
import { MainContent } from "../components/MainContent";

export const TopPage: FC = () => {
  return (
    <div className={styles.root}>
      <Header />
      <div className={styles.container}>
        <main className={styles.mainContainer}>
          <MainContent />
        </main>
        <Footer />
      </div>
    </div>
  );
};
