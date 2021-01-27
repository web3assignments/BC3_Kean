import { Component, OnInit } from '@angular/core';
import Web3 from 'web3';
import {FormsModule} from '@angular/forms'

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})

export class HomeComponent implements OnInit {
  gacha: any;
  error: string;
  option: number;
  result: any;
  //contract = "0x2acFAAA3f79bD127eC79BAC14d7BDD049d5DE828";
  contract = "gachaimpact.eth";
  account: any;
  web3 :any;
  Abi =  [
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "string",
          "name": "CharName",
          "type": "string"
        },
        {
          "indexed": false,
          "internalType": "uint8",
          "name": "Rating",
          "type": "uint8"
        }
      ],
      "name": "WantGachaPull",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "PullResultList",
      "outputs": [
        {
          "internalType": "string",
          "name": "naam",
          "type": "string"
        },
        {
          "internalType": "uint8",
          "name": "Rating",
          "type": "uint8"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "initialize",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getPullResultList",
      "outputs": [
        {
          "components": [
            {
              "internalType": "string",
              "name": "naam",
              "type": "string"
            },
            {
              "internalType": "uint8",
              "name": "Rating",
              "type": "uint8"
            }
          ],
          "internalType": "struct GachaV2.Unit[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "pull",
          "type": "uint256"
        }
      ],
      "name": "Start",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function",
      "payable": true
    },
    {
      "inputs": [
        {
          "internalType": "bytes32",
          "name": "_myid",
          "type": "bytes32"
        },
        {
          "internalType": "string",
          "name": "_result",
          "type": "string"
        }
      ],
      "name": "__callback",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "bytes32",
          "name": "_queryId",
          "type": "bytes32"
        },
        {
          "internalType": "string",
          "name": "_result",
          "type": "string"
        },
        {
          "internalType": "bytes",
          "name": "_proof",
          "type": "bytes"
        }
      ],
      "name": "__callback",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "RandomNumber",
          "type": "uint256"
        }
      ],
      "name": "setName",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ];

  constructor() {}

  ngOnInit():void {
    this.option = 1;
    this.asyncloaded();
  }

  async asyncloaded() {
    this.web3 = new Web3(Web3.givenProvider); // provider from metamask
    var result = await this.web3.eth.requestAccounts().catch(x => console.log(x.message));
    console.log(this.web3.version); // note: use  (back quote)
    const network = await this.web3.eth.net.getId().catch(reason => console.log(reason));
    if (typeof network === 'undefined' || network != 4) { console.log("Please select Rinkeby test network"); return; }
    console.log("Ethereum network: Rinkeby")
    var accounts = await this.web3.eth.getAccounts();
    this.account = accounts[0];
    console.log(accounts[0]); // show current user.
    this.gacha = new this.web3.eth.Contract( 
     this.Abi, this.contract);  
     var addr = this.web3.eth.ens.getAddress('gachaimpact.eth').then( (address) => {
      this.gacha = new this.web3.eth.Contract(this.Abi, address);
      console.log(this.gacha);
    });
     
}

  Start(amount:number) {
    this.gacha.methods.Start(amount).send({from:this.account, value: amount * 5000000000000000}).then((res: any) => {
      console.log(res);
    }).catch((err: any) => {
      console.error(err);
    });
  }

  getResult(){
    this.gacha.methods.getPullResultList().call({from:this.account}).then((res: any) => {
      console.log(res);
      this.result = res;
  })
  }ks
}