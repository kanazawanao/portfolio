import Header from "components/Header";
import Profile from "components/Profile";
import Skill from "components/Skill";

export default function App() {
  fetch("https://api.naz-pg.dev/ping")
    .then((res) => res.json())
    .then((json) => console.log(json))
    .catch(() => alert("error"));
  return (
    <>
      <Header />
      <Profile />
      <Skill />
    </>
  );
}
