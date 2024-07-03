// React_Q5 classNames関数の返り値の型をstringより詳しい型にしよう
type ClassNameJoin = string;

export const classNames = (...classes: string[]): ClassNameJoin =>
  // @ts-expect-error ここの型エラーは無視してください
  classes.join(" ");

// 返り値の型のチェック用
classNames("a", "b"); //      -> "a b"型にしたい
classNames("c", "d", "e"); // -> "c d e"型にしたい
classNames(""); //            -> ""型にしたい
classNames(); //              -> ""型にしたい
