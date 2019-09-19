import {AfterViewInit, ChangeDetectorRef, Component, Input, OnInit} from '@angular/core';

import {HeaderService} from '../services/header.service';
import {BaseData, BaseResult, MLAData, MLAlgorithm, User} from '../services/json.service';

@Component({
  selector: 'app-data-card',
  templateUrl: './data-card.component.html',
  styleUrls: ['./data-card.component.css']
})
export class DataCardComponent implements OnInit {
  @Input() public mlalgorithm: BaseResult;
  public _SelectedData: BaseData[] = [];
  selectedUser: User;
  UserOutlierNumber: number = 0;
  Percentage: string;

  @Input()
  set SelectedData(selectedData: BaseData[]) {
    this._SelectedData = selectedData;
    this.UserOutlierNumber = this._SelectedData
                                 .filter((entry: BaseData, idx: number) => {
                                   return entry.outlier === 1;
                                 })
                                 .length;
    this.Percentage =
        ((this.UserOutlierNumber / this.mlalgorithm.totalOutliers) * 100)
            .toFixed(2);
  }
  get SelectedData() {
    return this._SelectedData;
  }

  constructor(
      private headerService: HeaderService,
      private changeDetector: ChangeDetectorRef) {}

  ngOnInit() {
    this.SelectedData = this.getUserMLAData(this.selectedUser);
    this.headerService.getState().subscribe((selectedUser: User) => {
      this.selectedUser = selectedUser;
      this.SelectedData = this.getUserMLAData(this.selectedUser);
    });
  }

  getUserMLAData(user: User) {
    let data = this.mlalgorithm.data.filter((UserMLAData: BaseData) => {
      if (user)
        return UserMLAData.userID === user.USERSID;
      else
        return true;
    });
    return data;
  }
}
