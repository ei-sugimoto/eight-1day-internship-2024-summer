import * as fetchClient from "../utils/fetchClient";
import { Card } from "./cards";

export type Person = {
  id: number;
  cards: Card[];
  memo: string | null;
};

type GetPeopleParams = {
  offset?: number;
  query?: string;
};
export const getPeople = async (
  params: GetPeopleParams = { offset: 0 },
  options?: { signal: AbortSignal }
): Promise<Person[]> => {
  const response = await fetchClient.get("/apis/people.json", {
    data: {
      query: params.query || "",
    },
    ...options,
  });
  return response.json();
};
