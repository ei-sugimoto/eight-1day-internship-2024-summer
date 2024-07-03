import * as fetchClient from "../utils/fetchClient";

type PostPersonMemoParams = {
  person_id: number;
  content?: string;
};

export const postMemo = async (
  params: PostPersonMemoParams,
  options?: { signal: AbortSignal }
): Promise<void> => {
  // TODO
};
