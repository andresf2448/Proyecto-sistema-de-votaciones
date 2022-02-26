// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

contract Votaciones{
    //Direcion del propietario del contrato
    address owner;

    constructor(){
        owner = msg.sender;
    }

    //Relación entre el nombre del candidato y el hash de sus datos personales
    mapping(string => bytes32) ID_Candidato;

    //Relación entre el nombre del candidato y el número de votos
    mapping(string => uint) votos_candidato;

    //Lista  para almacenar los nombres de los candidatos
    string [] candidatos;

    //Lista de los hashes de la identidad de los votantes
    bytes32 [] votantes;

    //cualquier persona puede usar esta funcion para presentarse a las elecciones
    function Representar (string memory _nombrePersona, uint _edadPersona, string memory _idPersona) public{
        //Hash de los datos del candidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombrePersona, _edadPersona, _idPersona));

        //Almacenamos el hash de los datos del candidato ligados a su nombre
        ID_Candidato[_nombrePersona] = hash_Candidato;

        //Almacenamos el nombre del candidato
        candidatos.push(_nombrePersona);
    }

    //visualzar las personas que se han presentado como candidatos a las votaciones
    function VerCandidatos() public view returns(string[] memory){
        return candidatos;
    }

    //funcion para que las personas puedan votar
    function Votar(string memory _candidato) public{
        //Hash de la direccion de la persona que ejecuta la funcion
        bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));
        //verificamos si el votante ya ha votado
        for(uint i=0; i<votantes.length; i++){
            require(votantes[i] != hash_Votante, "Ya has votado previamente");
        }
        //almacenamos el hash del votante dentro del array de votantes
        votantes.push(hash_Votante);
        //Añadimos un voto al candidato seleccionado
        votos_candidato[_candidato]++;
    }

    //Dado el nombre de un candidato nos devuelve el numero de votos que tiene
    function VerVotos(string memory _candidato) public view returns(uint){
        //Devolviendo el numero de votos del candidato _candidato
        return votos_candidato[_candidato];
    }

    //funcion para transformar un uint a string
    function uint2str(uint _i) internal pure returns(string memory _uintAsString){
        if(_i == 0){
            return "0";
        }

        uint j = _i;
        uint len;

        while(j != 0){
            len++;
            j /= 10;
        }

        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }

        return string(bstr);
    }

    //ver los datos de cada uno de los candidatos
    function VerResultados() public view returns(string memory){
        //Guardamos en una variable string los candidatos con sus respectivos votos
        string memory resultados="";
        
        //Recorremos el array de candidatos para actualizar el string resultados
        for(uint i=0; i<candidatos.length; i++){
            //Actualizamos el string resultados y añadimos el candidato que ocupa la posicion "i" del array candidatos
            //y su numero de votos
            resultados = string(abi.encodePacked(resultados, "(", candidatos[i], ", ", uint2str(VerVotos(candidatos[i])), ") -----"));
        }
        
        //Devolvemos los resultados
        return resultados;
    }

    //Proporcionar el nombre del candidato ganador
    function Ganador() public view returns(string memory){
        
        //La variable ganador contendra el nombre del candidato ganador 
        string memory ganador= candidatos[0];
        bool flag;
        
        //Recorremos el array de candidatos para determinar el candidato con un numero de votos mayor
        for(uint i=1; i<candidatos.length; i++){
            
            if(votos_candidato[ganador] < votos_candidato[candidatos[i]]){
                ganador = candidatos[i];
                flag=false;
            }else{
                if(votos_candidato[ganador] == votos_candidato[candidatos[i]]){
                    flag=true;
                }
            }
        }
        
        if(flag==true){
            ganador = "Hay empate entre los candidatos";
            
        }
        return ganador;
    }
}