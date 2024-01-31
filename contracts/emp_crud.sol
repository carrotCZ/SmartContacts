// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

//jednoduchá CRUD aplikace pro vytváření, čtení, úpravu a mazaní údajů o zaměstnancích 
//rozšířená o možnost provádět platy výplat na etherum peněženky v databázi zaměstnaců

contract Crud{

        //inicializace minteru, který může razit mince (adresa tvůrce) a mapování adresy
        address public minter;
        mapping(address => uint) public balances;

        // deklarace událost, která je vyvolána v posledním řádku funkce pro platbu výplat
        event Sent(address from, address to, uint amount);

        //kontruktor sloužící k permanentnímu uložení adresy osoby, která vytvořila kontrakt
        constructor() {
        minter = msg.sender;
        }


        //definování struktury uživatele/zaměstnance
        struct zamestnanec{
            uint id;
            string jmeno;
            string mail;
            uint plat;
            address eth_adresa;
        }

        //pole se zaměstnanci
        zamestnanec[] zamestnanci;

        //id dalšího zaměstnance v poli
        uint nextId = 1;
        
        //funkce pro vytvoření nového zaměstnance
        function vytvorit_zam(string memory jmeno, string memory mail, uint plat,  address eth_adresa) public {
            zamestnanci.push(zamestnanec(nextId, jmeno, mail, plat, eth_adresa));
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
        function cist_zam(uint _id) view  public returns(uint, string memory, string memory, uint, address){
            uint i = najit(_id);         
            return(zamestnanci[i].id, zamestnanci[i].jmeno, zamestnanci[i].mail, zamestnanci[i].plat,  zamestnanci[i].eth_adresa);
        }


        //funkce pro úpravu dat zaměstnance na základě jeho ID
        function upravit_zam(uint _id, string memory jmeno, string memory mail, uint plat, address eth_adresa) public {
            uint i = najit(_id);  
            zamestnanci[i].jmeno = jmeno;
            zamestnanci[i].mail = mail;
            zamestnanci[i].plat = plat;
            zamestnanci[i].eth_adresa = eth_adresa;
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

        // funkce sloužící k zaslání daného množství nových coinů na adresu tvůrce kontraktu
        function ziskat_coiny(address receiver, uint amount) public {
            require(msg.sender == minter);
            balances[receiver] += amount;
        }

        // získání informace o chybě, proč nemohla operace proběhnout
        error NedostatekProstredku(uint pozadovano, uint dostupne);

        // funkce sloužící k zaslání výplaty na etherum adresu zaměstnance
        function platba_vyplaty(uint _id) public {
            uint i = najit(_id);   
            if (zamestnanci[i].plat > balances[msg.sender])
                revert NedostatekProstredku({
                    pozadovano: zamestnanci[i].plat,
                    dostupne: balances[msg.sender]
                });

            balances[msg.sender] -= zamestnanci[i].plat;
            balances[zamestnanci[i].eth_adresa] += zamestnanci[i].plat;
            emit Sent(msg.sender, zamestnanci[i].eth_adresa, zamestnanci[i].plat);
        }


}