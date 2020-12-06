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
  constructor() {}

  ngOnInit():void {
    this.option = 0;
    const contract = "0x6F7DbC6622FF695Eda25022FF0a6Ba05cf55f39D";
    let web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
    this.gacha = new web3.eth.Contract(
      [
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
          "stateMutability": "nonpayable",
          "type": "function"
        },
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
          "name": "PullResult",
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
          "type": "function"
        }
      ] , contract);

    console.log(this.gacha);
  }

  Start(amount:number) {
    this.gacha.methods.Start(amount).send({from:"0xf83e9122C35Db685495B6b94ab4ddD51a55c4020"}).then((res: any) => {
      console.log(res);
    }).catch((err: any) => {
      console.error(err);
    });
  }
}