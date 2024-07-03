import * as fetchClient from "../utils/fetchClient";

export type Card = {
  id: number;
  name: string;
  organization: string;
  department: string;
  title: string;
};

export const getCardImagePath = (cardId: number) =>
  `/apis/cards/${cardId}/image.jpeg`;

export const getCardImage = async (cardId: number): Promise<Blob> => {
  const response = await fetchClient.get(`/apis/cards/${cardId}/image.jpeg`);
  return response.blob();
};
