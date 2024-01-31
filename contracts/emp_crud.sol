// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

//Jendoduchá CRUD aplikace pro vytváření, čtení, úpravu a mazaní údajů o zaměstnancích
contract Crud{

        //definvání struktury užiavtele/zaměstnance
        struct zamestnanec{
            uint id;
            string jmeno;
            string mail;
            uint plat;
        }

        //pole se zaměstnanci
        zamestnanec[] zamestnanci;

        //id dalšího zaměstnance v poli
        uint nextId = 1;
        
        //funkce pro vytvoření nového zaměstnance
        function vytvorit_zam(string memory jmeno, string memory mail, uint plat) public {
            zamestnanci.push(zamestnanec(nextId, jmeno, mail, plat));
            nextId++;
        }

         //funkce pro výpis všech zaměstnanců (celého pole)
        function vsichni_zam() view public returns(zamestnanec[] memory){
            return(zamestnanci);
        }   

         //funkce pro zjisštění počtu zaměstnanců
        function pocet_zam() view public returns(uint pocet){
            return(zamestnanci.length);
        }   

        //funkce pro výpis dat o zaměstnanci na základě jeho ID
        function cist_zam(uint _id) view  public returns(uint, string memory, string memory, uint){
            uint i = najit(_id);         
            return(zamestnanci[i].id, zamestnanci[i].jmeno, zamestnanci[i].mail, zamestnanci[i].plat);
            }


        //funkce pro úpravu dat zaměstnance na základě jeho ID
        function upravit_zam(uint _id, string memory jmeno, string memory mail, uint plat) public {
            uint i = najit(_id);  
            zamestnanci[i].jmeno = jmeno;
            zamestnanci[i].mail = mail;
            zamestnanci[i].plat = plat;
            }

        //funkce pro výmaz zaměstnance na základě ID
        function vymazat_zam(uint _id)public{
            uint i = najit(_id); 
            delete zamestnanci[i];
        }


        //funkce pro nalezení zaměstnance v poli na základě ID
        function najit(uint id)view internal returns(uint){
            for(uint i=0; i < zamestnanci.length ;i++){
               if(zamestnanci[i].id == id){
                 return i;
               } 
            }
            revert('Zamestanenec neexistuje');
        }

}