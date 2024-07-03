import { useEffect, useState } from "react";
import { Person, getPeople } from "../apis/people";

export const usePeople = () => {
  const [query, setQuery] = useState("");

  const [isLoading, setIsLoading] = useState(false);
  const [data, setData] = useState<Person[]>([]);
  const [error, setError] = useState<Error | null>(null);

  const hasMore = true;

  const reset = () => {
    setData([]);
    setError(null);
  };

  useEffect(() => {
    const abortController = new AbortController();

    reset();
    setIsLoading(true);
    getPeople(query ? { query } : undefined, { signal: abortController.signal })
      .then(setData)
      .catch((error) => {
        console.error(error);
        setError(new Error("error"));
      })
      .finally(() => {
        setIsLoading(false);
      });

    return () => {
      abortController.abort();
    };
  }, [query]);

  const search = (text: string) => {
    setQuery(text);
  };

  // React_Q2: 名刺を全件表示できるようにしよう
  const fetchMore = async () => {
    // TODO
  };

  const updateMemo = (personId: number, memo: string) => {
    setData((people) =>
      people.map((person) =>
        person.id === personId ? { ...person, memo } : person
      )
    );
  };

  if (isLoading) {
    return {
      isLoading,
      data: null,
      error: null,
      search,
      fetchMore,
      hasMore,
      updateMemo,
    };
  }
  if (error) {
    return {
      isLoading,
      data: null,
      error,
      search,
      fetchMore,
      hasMore,
      updateMemo,
    };
  }
  return {
    isLoading,
    data,
    error: null,
    search,
    fetchMore,
    hasMore,
    updateMemo,
  };
};
