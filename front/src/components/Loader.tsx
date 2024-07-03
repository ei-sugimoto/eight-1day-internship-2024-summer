import { FC, useEffect, useRef, useState } from "react";
import styles from "./Loader.module.css";
import { classNames } from "../utils/classNames";

export const Loader: FC<{ onVisible: VoidFunction }> = ({ onVisible }) => {
  const ref = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    // TODO
  }, []);

  return (
    <section className={styles.root} ref={ref}>
      <div
        className={classNames(
          styles.spinner,
          isVisible ? styles.visible : styles.invisible
        )}
      />
    </section>
  );
};
