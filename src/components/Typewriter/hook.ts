import { useEffect, useState } from "react";

export default function useTypewriter(text: string, speed: number) {
  const [displayText, setDisplayText] = useState("");
  useEffect(() => {
    let i = 0;
    const typingInterval = setInterval(() => {
      if (i < text.length) {
        setDisplayText((prevText) => `${prevText}${text[i++]}`);
      } else {
        clearInterval(typingInterval);
      }
    }, speed);

    return () => {
      clearInterval(typingInterval);
    };
  }, [text, speed]);

  return displayText;
}
