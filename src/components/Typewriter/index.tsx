import useTypewriter from "./hook";

export default function Typewriter() {
  const displayText = useTypewriter("こんにちは、私は金澤直です。", 75);
  return <>{displayText}|</>;
}
