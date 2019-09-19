import { Component, Input, OnInit } from '@angular/core';

import { HeaderService } from '../services/header.service';
import { JsonService, User, UserClass } from '../services/json.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})

export class HeaderComponent implements OnInit {
  title = 'Blackbaud Fraud Detection Results';
  public UsersData: User[] = [];
  public UsersDataPath = '../assets/Users.json';
  private BLANK_USER: User = new UserClass();
  @Input()
  selectedUser: User = this.BLANK_USER;

  constructor(
    private jsonService: JsonService, private headerService: HeaderService) { }

  ngOnInit() {
    this.getJSONUsersData();
  }

  broadcastSelection() {
    this.headerService.setState(this.selectedUser);
  }

  isInObjectValues(data: Object, text: string) {
    for (let key in data) {
      if (typeof data[key] === 'string' && data[key].indexOf(text) > -1)
        return true;
    }
    return false;
  }

  findUser(query: any) {
    let results: User[] = this.UsersData.filter((user: User, idx: number) => {
      return this.isInObjectValues(user, query);
    });
    return results[0];
  }

  getJSONUsersData() {
    this.jsonService.getJSONUsersData(this.UsersDataPath).subscribe(data => {
      this.UsersData = data.sort((a: User, b: User) => {
        let sortField = 'NAME';
        let val1 = a[sortField];
        let val2 = b[sortField];
        if (val1 && typeof val1 === 'string') val1 = val1.toLowerCase();
        if (val2 && typeof val2 === 'string') val2 = val2.toLowerCase();
        let result = val1 > val2 ? 1 : -1;
        return result;
      });
      // this.UsersData.unshift(this.BLANK_USER);
      // this.selectedUser = this.UsersData[7];  // this.findUser('tsmith');
      this.broadcastSelection();
    });
  }
}
