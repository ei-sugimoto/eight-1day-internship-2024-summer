import { useCallback, useRef } from "react";
import { Func } from "./types";

const DELAY_MS = 1000; // ミリ秒

export const useDebouncedFunc = <F extends Func>(func: F) => {
  const funcRef = useRef(func);
  funcRef.current = func; // 常に最新の値に更新する

  const debouncedFunc = useCallback(() => {
    // TODO
  }, []);

  return debouncedFunc;
};
