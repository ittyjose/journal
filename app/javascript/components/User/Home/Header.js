import React from "react";
import { useHistory } from "react-router-dom";

import { logout } from "Apis/authentication";
import Button from "components/Common/Button";

function Header() {
  const history = useHistory();

  const handleLogout = () => {
    logout();
    history.push("/");
  };

  return (
    <nav className="flex justify-between items-center px-4 py-3 border-b-2 border-gray-100 md:space-x-10">
      <div><a href="/user">
        <h1 className="text-xl text-indigo-600 font-bold">Journal</h1>
      </a></div>
      <div>
        <Button
          htmlType="button"
          className="border-transparent"
          onClick={handleLogout}
        >
          Logout
        </Button>
      </div>
    </nav>
  );
}

export default Header;
