import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/publishReplay';

export interface User {
  USERSID: number;
  NAME: string;
  DESCRIPTION: string;
}
export class UserClass implements User {
  USERSID: number;
  NAME: string;
  DESCRIPTION: string;
  constructor() {
    this.USERSID = -1;
    this.NAME = '';
    this.DESCRIPTION = '';
  }
}
export interface BaseResult {
  name: string;
  totalOutliers: number;
  data: BaseData[];
}
export interface BaseData {
  id: number;
  userID: number;
  AP7INVOICESID: number;
  CHECKS7ID: number;
  PaymentAmount: number;
  CheckAddedbyID: number;
  InvoiceAddedbyID: number;
  PAYMENTMETHOD: number;
  DeltaTime: number;
  HOD: number;
  DOW_num: number;
  DOW_str: string;
  outlier: number;
}
export interface COResult {
  name: string;
  totalOutliers: number;
  data: COData[];
}
export interface COData {
  id: number;
  userID: number;
  AP7INVOICESID: number;
  CHECKS7ID: number;
  PaymentAmount: number;
  CheckAddedbyID: number;
  InvoiceAddedbyID: number;
  PAYMENTMETHOD: number;
  DeltaTime: number;
  HOD: number;
  DOW_num: number;
  DOW_str: string;
  outlier: number;
}
export interface SpecialUseCaseData {
  id: number;
  AP7INVOICESID: number;
  CHECKS7ID: number;
  CheckAmount: number;
  PAYMENTDATE: string;
  CheckAddedDate: string;
  INVOICEDATE: string;
  PAYEENAME: string;
  InvoiceAddedByName: string;
  CheckAddedByName: string;
}
export interface MLAlgorithm {
  name: string;
  totalOutliers: number;
  data: MLAData[];
  globalTitle: string;
  localTitle: string;
  xlab: string;
  ylab: string;
}
export interface MLAData {
  id: number;
  userID: number;
  AP7INVOICESID: number;
  CHECKS7ID: number;
  PaymentAmount: number;
  CheckAddedbyID: number;
  InvoiceAddedbyID: number;
  PAYMENTMETHOD: number;
  DeltaTime: number;
  HOD: number;
  DOW_num: number;
  DOW_str: string;
  cluster: number;
  outlier: number;
  xCoord: number;
  yCoord: number;
}

@Injectable()
export class JsonService {
  UsersData: Observable<any> = null;
  CommonOutliers: Observable<any> = null;
  SpecialUseCase: Observable<any> = null;
  MLData: Observable<any> = null;

  constructor(private http: HttpClient) { }

  getJSONUsersData(file: string) {
    if (!this.UsersData) {
      this.UsersData = this.http.get<[User]>(file).publishReplay(1).refCount();
    }
    return this.UsersData;
  }

  getJSONCO(file: string) {
    if (!this.CommonOutliers) {
      this.CommonOutliers = this.http.get<COResult>(file).publishReplay(1).refCount();
    }
    return this.CommonOutliers;
  }

  getJSONSUC(file: string) {
    if (!this.SpecialUseCase) {
      this.SpecialUseCase = this.http.get<[SpecialUseCaseData]>(file).publishReplay(1).refCount();
    }
    return this.SpecialUseCase;
  }

  getJSONMLAD(file: string) {
    if (!this.MLData) {
      this.MLData = this.http.get<[MLAlgorithm]>(file).publishReplay(1).refCount();
    }
    return this.MLData;
  }
}
