const headersWithCsrfToken = (headers: Headers) => {
  const csrfToken =
    document
      .querySelector("meta[name='csrf-token']")
      ?.getAttribute("content") || "";
  headers.set("Content-Type", "application/json");
  headers.set("X-CSRF-Token", csrfToken);

  return headers;
};

export const get = (
  baseUrl: string,
  {
    data,
    signal,
  }: {
    data?: string[][] | Record<string, string> | string | URLSearchParams;
    signal?: AbortSignal;
  } = {}
) => {
  const searchParams = new URLSearchParams(data).toString();
  const url = baseUrl + (searchParams ? `?${searchParams}` : "");
  return fetch(url, { signal });
};

export const post = (
  url: string,
  {
    data = {},
    headers = new Headers(),
    signal,
  }: {
    data?: Record<string, unknown>;
    headers?: Headers;
    signal?: AbortSignal;
  } = {}
) => {
  return fetch(url, {
    method: "POST",
    headers: headersWithCsrfToken(headers),
    body: JSON.stringify(data),
    signal,
  });
};
