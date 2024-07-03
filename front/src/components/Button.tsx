import { ButtonHTMLAttributes, FC } from "react";
import styles from "./Button.module.css";
import { classNames } from "../utils/classNames";

type NativeButtonProps = Omit<
  ButtonHTMLAttributes<HTMLButtonElement>,
  "className"
>;

export const Button: FC<
  NativeButtonProps & {
    variant?: "primary" | "secondary";
    size?: "small" | "medium";
  }
> = ({ variant = "secondary", size = "medium", children, ...rest }) => {
  return (
    <button
      className={classNames(styles.root, styles[variant], styles[size])}
      {...rest}
    >
      {children}
    </button>
  );
};
