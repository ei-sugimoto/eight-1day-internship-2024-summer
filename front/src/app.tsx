import "./variables.css";
import "./style.css";

import { createRoot } from "react-dom/client";

import { TopPage } from "./pages/TopPage";

const rootElement = document.getElementById("root");
if (rootElement) {
  createRoot(rootElement).render(<TopPage />);
}
