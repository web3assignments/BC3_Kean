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
  AllResult: any;
  //contract = "0xa9103Ff403E635E65192F359060F84A0DeF6B06C";
  contract = "GachaImpact.eth";
  account: any;
  web3 :any;
  Abi =  [
    {
      "inputs": [],
      "name": "initialize",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
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
          "internalType": "struct Gacha.Unit[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "getAllResult",
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
          "internalType": "struct Gacha.Unit[]",
          "name": "",
          "type": "tuple[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    },
    {
      "inputs": [],
      "name": "PullCharacter",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "RNG",
          "type": "uint256"
        }
      ],
      "name": "setCharachter",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "extra",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "divide",
          "type": "uint256"
        }
      ],
      "name": "RandomGenerator",
      "outputs": [
        {
          "internalType": "uint8",
          "name": "",
          "type": "uint8"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
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
        var addr = this.web3.eth.ens.getAddress('gachaimpact.eth').then( (address) => {
      this.gacha = new this.web3.eth.Contract(this.Abi, address);
      this.gacha.events.Summon({fromBlock: "latest"}, (error: any, event: any) =>{
        console.log(event.returnValues.unit);
      });
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

  getAllResult(){
    this.gacha.methods.getAllResult().call({from:this.account}).then((res: any) => {
      console.log(res);
      this.AllResult = res;
    })
  }

  getResult(){
    this.gacha.methods.getPullResultList().call({from:this.account}).then((res: any) => {
      console.log(res);
      this.result = res;
    })
  }
}