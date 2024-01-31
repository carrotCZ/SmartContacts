// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.13;

//Aplicación CRUD - Create / Read / Update & Delete
contract Crud{

        //Estructura de un usuario
        struct zamestnanec{
            uint id;
            string jmeno;
            string mail;
            uint plat;
        }

        //Lista de los usuarios
        zamestnanec[] zamestnanci;

        //Proximo id del usuario
        uint nextId = 1;
        
        //Funcion para crear un usuario
        function vytvorit_zam(string memory jmeno, string memory mail, uint plat) public {
            zamestnanci.push(zamestnanec(nextId, jmeno, mail, plat));
            nextId++;
        }

         //Funcion para crear un usuario
        function vsichni_zam() view public returns(zamestnanec[] memory){
            return(zamestnanci);
        }   

         //Funcion para crear un usuario
        function pocet_zam() view public returns(uint pocet){
            return(zamestnanci.length);
        }   

        //Funcion para obtener los datos de un usuario con el id.
        function cist_zam(uint _id) view  public returns(uint, string memory, string memory, uint){
            uint i = najit(_id);         
            return(zamestnanci[i].id, zamestnanci[i].jmeno, zamestnanci[i].mail ,zamestnanci[i].plat);
            }


        //Funcion actualizar datos usuario.
        function upravit_zam(uint _id, string memory jmeno, string memory mail, uint plat) public {
            uint i = najit(_id);  
            zamestnanci[i].jmeno = jmeno;
            zamestnanci[i].mail = mail;
            zamestnanci[i].plat = plat;
            }

        //Funcion eliminar usuario.
        function vymazat_zam(uint _id)public{
            uint i = najit(_id); 
            delete zamestnanci[i];
        }


        //Funcion para buscar el id del usuario.
        function najit(uint id)view internal returns(uint){
            for(uint i=0; i < zamestnanci.length ;i++){
               if(zamestnanci[i].id == id){
                 return i;
               } 
            }
            revert('Zamestanenec neexistuje');
        }

}